Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0H3IBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:01:07 -0400
Received: from lo.gmane.org ([80.91.229.12]:43250 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab0H3IBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:01:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: Linux 2.6.36-rc3
Date: Mon, 30 Aug 2010 08:00:52 +0000 (UTC)
Message-ID: <loom.20100830T095351-185@post.gmane.org>
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com> <loom.20100830T003135-767@post.gmane.org> <20100830052358.GA3506@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 203.185.183.145 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100809 Mandriva Linux/1.9.2.8-0.1mdv2010.1 (2010.1) Firefox/3.6.8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp <at> alien8.de> writes:

> 
> From: Jean-Denis Girard <jd.girard <at> sysnux.pf>
> Date: Sun, Aug 29, 2010 at 10:40:47PM +0000
> 
> >   CC      drivers/gpu/drm/i915/intel_overlay.o
> > drivers/gpu/drm/i915/intel_overlay.c: In function 
> > ‘intel_overlay_print_error_state’:
> > drivers/gpu/drm/i915/intel_overlay.c:1467: erreur: implicit declaration 
> > of function ‘seq_printf’
> > make[4]: *** [drivers/gpu/drm/i915/intel_overlay.o] Erreur 1
> > make[3]: *** [drivers/gpu/drm/i915] Erreur 2
> > make[2]: *** [drivers/gpu/drm] Erreur 2
> > make[1]: *** [drivers/gpu] Erreur 2
> > make: *** [drivers] Erreur 2
> > Command exited with non-zero status 2
> 
> This should fix it:

Yes, problem fixed.


Thanks,
-- 
Jean-Denis Girard

SysNux                  Systèmes  Linux  en Polynésie française
http://www.sysnux.pf/   Tél: +689 50 10 40 / GSM: +689 79 75 27

