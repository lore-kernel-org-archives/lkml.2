Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2IRUyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:54:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64878 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab2IRUyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:54:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120918102141.GB4118@daedalus.informatik.rwth-aachen.de>
References: <1340164055-1062-1-git-send-email-alex.hung@canonical.com>
	<20120626213958.GA17871@burratino>
	<20120626215806.GM21479@carsten-otto>
	<4FEABBFC.6090708@canonical.com>
	<20120627221743.GC13738@burratino>
	<20120918102141.GB4118@daedalus.informatik.rwth-aachen.de>
Date: Tue, 18 Sep 2012 21:54:01 +0100
X-Google-Sender-Auth: RW0QFVOpPeVBt1jyEf52f1YA69c
Message-ID: <CAHR064hJPrp=2xdpcTMJuKtEJsrfQsJkKomjvN+Pkty9uUCEFQ@mail.gmail.com>
Subject: Re: [PATCH] asus-wmi: use ASUS_WMI_METHODID_DSTS2 as default DSTS ID.
From: Corentin Chary <corentincj@iksaif.net>
To: Carsten Otto <otto@informatik.rwth-aachen.de>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Alex Hung <alex.hung@canonical.com>, corentincj@iksaif.net,
        mjg@redhat.com, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        679158@bugs.debian.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 18, 2012 at 11:21 AM, Carsten Otto
<otto@informatik.rwth-aachen.de> wrote:
> Dear all,
>
> the patch seems to be integrated in 3.5.4 (current stable kernel). When
> rebasing using git I see that the patch is not applied on top, most
> likely because it was already included somewhere in the official stable
> Linux itself.

Easy workaround is to blacklist/remove asus-wmi (and/or
eeepc-wmi/asus-nb-wmi). I think ubuntu guys are working on it, and
since they seems to be working with Asus (and I'm not), it will be
easier for them.

> As mentioned in the following Ubuntu bug report, this patch causes
> problems (which I also observe).
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1041883
>
> It takes me about 10 tries to successfully boot my system. In the
> unsuccessful tries the screen is blanked shortly during the boot process
> and nothing happens (the magic keys don't work, network access cannot be
> tested that early).
>
> Bye,
> --
> Carsten Otto           otto@informatik.rwth-aachen.de
> LuFG Informatik 2      http://verify.rwth-aachen.de/otto/
> RWTH Aachen            phone: +49 241 80-21211
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.12 (GNU/Linux)
>
> iEYEARECAAYFAlBYSzUACgkQjUF4jpCSQBQpbgCfSUUvaZbs1krkcRKa8iTcyKxA
> 7AQAn1NfXugZ5553+Z9LOB46lJqFcXt8
> =avwS
> -----END PGP SIGNATURE-----
>



-- 
Corentin Chary
http://xf.iksaif.net
