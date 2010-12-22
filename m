Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0LVNLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:11:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34616 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab0LVNLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:11:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=o8PatkCLv85sGh9AEY4gx4g2YfmrrkTHZfl8FF0cKrjaYBdBLeP5uHEa31qtm+iS/7
         RUI6GO15Imopc+fd53FgPp3gaUb18IN1QhcNI2r7CvJmmXIqXCmq3zT/AYvCSHKVal5w
         x/gLba/CkwQGWzaYCD7XHjLnqzSsROobU3uoE=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 0/6] Minor cleanups & fixes for perf-probe(1)
References: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
	<4D10A795.9040809@hitachi.com> <m3aajzc8f1.fsf@gmail.com>
	<20101221210502.GA29079@ghostprotocols.net>
Date: Wed, 22 Dec 2010 14:11:37 +0100
In-Reply-To: <20101221210502.GA29079@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 21 Dec 2010 19:05:02 -0200")
Message-ID: <m38vzit0ja.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo <acme@ghostprotocols.net> writes:

[...]

>
> I did just that s/fprintf/color_fprintf/g change Masami asked and
> stashed everything in my perf/core branch.

Thanks.

Should I still send some details about what patches do ?

-- 
		Franck
