Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab1I3DAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 23:00:12 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33799 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab1I3DAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 23:00:10 -0400
Date: Fri, 30 Sep 2011 10:59:51 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ram Pai <linuxram@us.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, weiyang@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, shangw@linux.vnet.ibm.com,
        Michal Ludvig <mludvig@logix.net.nz>
Subject: Re: [PATCH] Resource: wrong resource window calculation
Message-ID: <20110930025951.GA2432@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <CAErSpo6bofeiAxeRo_RjXQSnwmcWrdymn0MK8H4_CwqwoeD1jg@mail.gmail.com>
 <4E634814.4050508@logix.net.nz>
 <20110909113409.GE2416@ram-ThinkPad-T61>
 <4E6C05B7.9000904@logix.net.nz>
 <20110913110646.GB2425@ram-ThinkPad-T61>
 <4E6F400A.6090909@logix.net.nz>
 <20110922074858.GG5085@ram-ThinkPad-T61>
 <4E7B04F8.3090500@logix.net.nz>
 <20110928154200.GA2477@ram-ThinkPad-T61>
 <CA+55aFxAHTWu=ZVoMdfGwJ4xNgGeyk2CWrD+kJVH-qb4N=vhwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxAHTWu=ZVoMdfGwJ4xNgGeyk2CWrD+kJVH-qb4N=vhwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 07:44:17PM -0700, Linus Torvalds wrote:
> On Wed, Sep 28, 2011 at 8:42 AM, Ram Pai <linuxram@us.ibm.com> wrote:
> >
> >        Do you plan to take this patch for 3.1? It fixes a regression w.r.t 3.0
> >        https://bugzilla.kernel.org/show_bug.cgi?id=42002 captures the bug report.
> 
> It looks fine, but that bugzilla thing is currently useless. Do you
> have some other place with the symptoms, discussion etc?  I didn't
> find the original report on lkml..


It was initially reported by Michal Ludwig in the linux-pci mailing list.
The following thread captures the discussion
http://comments.gmane.org/gmane.linux.kernel.pci/11666

RP
