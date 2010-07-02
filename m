Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab0GBN7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 09:59:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab0GBN7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 09:59:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KKjSybNKDISm5db2WZ3P4dGZqa9sl720QsSkNQ2BJ8MGv/jMSMXOhmeGCi/r9twPWV
         iw1In156f7177ZWytGqIncLwAgP7XnzvkhZ3hTeKHb8Vq/u6FyYeNuVPGHdifoyXgxj/
         mMiqX1SE+3qha0C2wZ4Uaw5aldgZkgQgC1bCI=
Date: Fri, 2 Jul 2010 17:03:53 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: Re: reiserfs locking (v2)
Message-ID: <20100702140353.GA3981@swordfish.minsk.epam.com>
References: <20100702093451.GA3973@swordfish.minsk.epam.com>
 <20100702131248.GA5324@nowhere>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20100702131248.GA5324@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/02/10 15:12), Frederic Weisbecker wrote:
> > As well as this:
> >=20
> > [  202.300464] REISERFS error (device sda9): vs-2100 add_save_link:
> > search_by_key ([-1 7812832 0x1 IND]) returned 1
> > [  202.300473] REISERFS (device sda9): Remounting filesystem read-only
> > [  202.301603] ------------[ cut here ]------------
> > [  202.301615] WARNING: at fs/reiserfs/journal.c:3436
> > journal_end+0x5b/0xaf()
> > [  202.301619] Hardware name: F3JC               =20
> > [  202.301622] Modules linked in: snd_seq_dummy snd_seq_oss
> > snd_seq_midi_event snd_seq snd_seq_device snd_hda_codec_si3054
> > snd_hda_codec_realtek snd_hwdep snd_pcm_oss snd_mixer_oss asus_laptop
> > sparse_keymap sdhci_pci sdhci snd_hda_intel mmc_core led_class snd_hda_=
codec
> > rng_core snd_pcm snd_timer snd_page_alloc snd i2c_i801 soundcore psmous=
e sg
> > evdev serio_raw r8169 mii usbhid hid uhci_hcd ehci_hcd sr_mod usbcore c=
drom
> > sd_mod ata_piix
> > [  202.301689] Pid: 5055, comm: a.out Not tainted
> > 2.6.35-rc3-dbg-git6-00502-g94feaba-dirty #65
> > [  202.301693] Call Trace:
> > [  202.301701]  [<c102e3a2>] warn_slowpath_common+0x65/0x7a
> > [  202.301707]  [<c1102d95>] ? journal_end+0x5b/0xaf
> > [  202.301712]  [<c102e3c6>] warn_slowpath_null+0xf/0x13
> > [  202.301718]  [<c1102d95>] journal_end+0x5b/0xaf
> > [  202.301725]  [<c10eebaa>] reiserfs_truncate_file+0x19f/0x233
> > [  202.301733]  [<c10f1ba1>] reiserfs_vfs_truncate_file+0xd/0xf
> > [  202.301738]  [<c1084883>] vmtruncate+0x23/0x29
> > [  202.301745]  [<c10b4ad4>] inode_setattr+0x47/0x68
> > [  202.301751]  [<c10f1b3f>] reiserfs_setattr+0x242/0x297
> > [  202.301758]  [<c12c5d05>] ? down_write+0x22/0x2a
> > [  202.301764]  [<c10b4d6f>] notify_change+0x15c/0x26b
> > [  202.301770]  [<c10a35c7>] do_truncate+0x64/0x7d
> > [  202.301776]  [<c12c69b0>] ? _raw_spin_unlock+0x33/0x3f
> > [  202.301783]  [<c10ad892>] do_last+0x450/0x459
> > [  202.301789]  [<c10ada5b>] do_filp_open+0x1c0/0x41a
> > [  202.301798]  [<c1029081>] ? get_parent_ip+0xb/0x31
> > [  202.301804]  [<c1029123>] ? sub_preempt_count+0x7c/0x89
> > [  202.301810]  [<c10b5746>] ? alloc_fd+0xb4/0xbf
> > [  202.301816]  [<c10a3f46>] do_sys_open+0x48/0xdf
> > [  202.301821]  [<c10a3ffb>] sys_open+0x1e/0x26
> > [  202.301827]  [<c10027d3>] sysenter_do_call+0x12/0x32
> > [  202.301833] ---[ end trace c4e3312bdadd2dc5 ]---
>=20
>=20
>=20
> Ah that's wicked. I'll try your testcase for that too.
>=20
> Thanks a lot for providing these!
>=20

I'm not very lucky at hitting this. Saw it several times (may be 3).


	Sergey

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwt8ckACgkQfKHnntdSXjSAyAP/eiMA2fSJhLWI2qSE9shrCFZ/
AJJ/jvl0TmfiuDYC4tmjQ27Mxwxf1em+6Rg012Y4DHXwXl2os3azCEq7UkNs+m0w
bEoSOxa30wZYqEHiPfj+dZUSvOWK8G9AeRr7nJkuY3Hopv/hU5IxJ9PTF095P8sJ
xTxlNXtrBEujq5Dkgt8=
=uOq4
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
