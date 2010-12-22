Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0LVOnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:43:46 -0500
Received: from canuck.infradead.org ([134.117.69.58]:51454 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0LVOnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:43:45 -0500
Date: Wed, 22 Dec 2010 12:43:38 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Subject: Re: [tip:perf/core] perf probe: Don't always consider EOF as an
	error when listing source code
Message-ID: <20101222144338.GA17134@ghostprotocols.net>
References: <1292854685-8230-6-git-send-email-fbuihuu@gmail.com> <tip-fde52dbd7f71934aba4e150f3d1d51e826a08850@git.kernel.org> <m34oa6t0e4.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m34oa6t0e4.fsf@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 22, 2010 at 02:14:43PM +0100, Franck Bui-Huu escreveu:
> tip-bot for Franck Bui-Huu <fbuihuu@gmail.com> writes:
> >  error:
> > -	if (feof(fp))
> > +	if (ferror(fp)) {
> >  		pr_warning("Source file is shorter than expected.\n");
> > -	else
> > -		pr_warning("File read error: %s\n", strerror(errno));
> > +		return -1;
> 
> Argh, something wrong here.
> 
> The warning left here, is the wrong one, I should have left the other
> one.
> 
> Sorry for the mistake.
> 
> Should I send a patch to fix that ?

Please.

- Arnaldo
