Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab1IRS6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 14:58:32 -0400
Received: from shutemov.name ([188.40.19.243]:51094 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab1IRS6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 14:58:31 -0400
Date: Sun, 18 Sep 2011 21:58:30 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 2/7] socket: initial cgroup code.
Message-ID: <20110918185830.GB28057@shutemov.name>
References: <1316051175-17780-1-git-send-email-glommer@parallels.com>
 <1316051175-17780-3-git-send-email-glommer@parallels.com>
 <20110917175207.GB1658@shutemov.name>
 <4E75664B.9070605@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E75664B.9070605@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 12:32:27AM -0300, Glauber Costa wrote:
> On 09/17/2011 02:52 PM, Kirill A. Shutemov wrote:
> > Do we really need to have these functions in the header?
> >
> No, I can move it to memcontrol.c
> 

Yes, please.

-- 
 Kirill A. Shutemov
