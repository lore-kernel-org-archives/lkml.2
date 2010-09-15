Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0IOQLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:11:05 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:44594 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab0IOQLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:11:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] tracing: Remove leftover FTRACE_ENABLE/DISABLE_MCOUNT enums
In-Reply-To: Your message of "Tue, 14 Sep 2010 23:01:42 EDT."
             <20100915030402.346004778@goodmis.org>
From: Valdis.Kletnieks@vt.edu
References: <20100915030139.444219083@goodmis.org>
            <20100915030402.346004778@goodmis.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1284567033_4463P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Sep 2010 12:10:33 -0400
Message-ID: <11102.1284567033@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4C90EFF9.022A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1284567033_4463P
Content-Type: text/plain; charset=us-ascii

On Tue, 14 Sep 2010 23:01:42 EDT, Steven Rostedt said:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The enums for FTRACE_ENABLE_MCOUNT and FTRACE_DISABLE_MCOUNT were
> used as commands to ftrace_run_update_code(). But these commands
> were used by the old nasty ftrace daemon that has long been slain.

> -	FTRACE_START_FUNC_RET		= (1 << 5),
> -	FTRACE_STOP_FUNC_RET		= (1 << 6),
> +	FTRACE_START_FUNC_RET		= (1 << 3),
> +	FTRACE_STOP_FUNC_RET		= (1 << 4),

This renumber isn't visible to user space, correct? (Asking because the enable/
disable apparently *were* visible to the since-slain userspace daemon)


--==_Exmh_1284567033_4463P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMkO/5cC3lWbTT17ARAh8YAKClxHNxQ7P625qAygKaw8AD5asqXQCgsl4d
3aCf6mj6wAE0p254BNGwrxw=
=MmHI
-----END PGP SIGNATURE-----

--==_Exmh_1284567033_4463P--

