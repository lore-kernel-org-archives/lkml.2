Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab0CSIAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 04:00:18 -0400
Received: from ozlabs.org ([203.10.76.45]:40317 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab0CSIAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 04:00:17 -0400
From: Jeremy Kerr <jk@ozlabs.org>
To: users@linux.kernel.org
Subject: Re: [kernel.org users] [KORG] Availability of SSL on kernel.org
Date: Fri, 19 Mar 2010 16:00:13 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, "J.H." <warthog9@kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4BA2CFB7.7070108@kernel.org> <20100319035806.GB25308@linux-sh.org>
In-Reply-To: <20100319035806.GB25308@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003191600.13474.jk@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Thanks for the report and testing - I've just committed a fix, plus a change 
to reflect the https URL in the sample .pwclientrc file.

J.H.: If you update to the current git HEAD, the pwclient and .pwclientrc 
files served by patchwork.kernel.org will now be more suitable for use with 
https.

Cheers,


Jeremy
