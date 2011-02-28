Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1B1Kqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:46:40 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33052 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1B1Kqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:46:39 -0500
Date: Mon, 28 Feb 2011 10:46:35 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        shiraz.hashim@st.com, amit.goel@st.com, armando.visconti@st.com
Subject: Re: [PATCH 3/8 resend] dw_dmac: call dwc_scan_descriptor from
 dwc_issue_pending only if active list is empty
Message-ID: <20110228104635.GB2754@pulham.picochip.com>
References: <cover.1298889267.git.viresh.kumar@st.com>
 <8003205172278ef36cfca1fd50a54cb143fad958.1298889267.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8003205172278ef36cfca1fd50a54cb143fad958.1298889267.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 04:11:18PM +0530, Viresh Kumar wrote:
> dwc_scan_descriptor was called even when there were descriptors in active list.
> Checking if active list is empty or not.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Hi Viresh,

I have a similar patch to this that is already in next that should 
achieve the same thing (dmaengine/dw_dmac: don't scan descriptors if no 
xfers in progress).

Jamie
