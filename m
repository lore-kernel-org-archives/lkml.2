Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895Ab0KBJfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 05:35:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46754 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0KBJfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 05:35:07 -0400
To: Florian Mickler <florian@mickler.org>
CC: miklos@szeredi.hu, tiwai@suse.de, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
In-reply-to: <20101031120452.31836af2@schatten.dmk.lab> (message from Florian
	Mickler on Sun, 31 Oct 2010 12:04:52 +0100)
Subject: Re: [REGRESSION] no sound on T60 laptop (HDA Intel)
References: <E1P33mT-0003qa-Fv@pomaz-ex.szeredi.hu>
	<s5hwrpxnf41.wl%tiwai@suse.de>
	<E1P3EES-0005SV-Sr@pomaz-ex.szeredi.hu>
	<s5h8w2b6f9c.wl%tiwai@suse.de>
	<E1P3PKg-0006RB-KV@pomaz-ex.szeredi.hu> <20101031120452.31836af2@schatten.dmk.lab>
Message-Id: <E1PDDGc-0000pM-83@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 02 Nov 2010 10:34:58 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Oct 2010, Florian Mickler wrote:
> > Hmm, now there's no sound even with the revert.  I guess reproducing
> > this is not completely reliable so the bisect gave a false result.  Oh
> > well.
> > 

> Did you get to the bottom of this?

No, the regression is still there in 2.6.36-final.

Thanks,
Miklos
