Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab1IIGHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 02:07:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62291 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758383Ab1IIGHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 02:07:40 -0400
Date: Fri, 9 Sep 2011 14:07:25 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Nallasellan, Singaravelan" <singaravelan.nallasellan@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Player Thread is not woken after period elapsed
Message-ID: <20110909060725.GA21124@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <3CA6C6D9F70D314CA34352990B57DA1507C420F147@bgsmsx502.gar.corp.intel.com>
 <20110905105253.2787b91f@infradead.org>
 <3CA6C6D9F70D314CA34352990B57DA1507C420F15C@bgsmsx502.gar.corp.intel.com>
 <20110905112225.72b46ac9@infradead.org>
 <3CA6C6D9F70D314CA34352990B57DA1507C4275D58@bgsmsx502.gar.corp.intel.com>
 <20110906200614.57a99d3d@infradead.org>
 <3CA6C6D9F70D314CA34352990B57DA1507C42767FA@bgsmsx502.gar.corp.intel.com>
 <20110908021327.GA8890@zhy>
 <20110908072948.GB11124@zhy>
 <3CA6C6D9F70D314CA34352990B57DA1507C42C3CA5@bgsmsx502.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <3CA6C6D9F70D314CA34352990B57DA1507C42C3CA5@bgsmsx502.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 03:15:38PM +0530, Nallasellan, Singaravelan wrote:
> > > > Further investigation of this issue shows that the thread is in running state

Hmm, how do you detect it?

> > and it is not scheduled. I am not sure how I will go about debugging this issue.
> > Any pointer would help.

Could 'cat /proc/sched_debug' give some useful info?

And BTW, have you tried CONFIG_DETECT_SOFTLOCKUP = y?

Thanks,
Yong


> > >
> > > Could you confirm if [commit f26f9af Sched: fix skip_clock_update
> > > optimization] residents in your kernel?
> I applied this patch manually. I still see the issue.
> > 
> > And commit da7a735e51f9622eb3e1672594d4a41da01d7e4f
> > http://marc.info/?l=linux-kernel&m=129527509622696&w=2
> This is already applied.
> ��칻�&�~�&���+-��ݶ��w��˛���m�b��dz�ޖ)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥>W����i�axPj�m����-�+��d�_

-- 
Only stand for myself
