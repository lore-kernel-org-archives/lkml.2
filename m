Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2K1IjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 03:39:07 -0500
Received: from mail2.efacec.com ([62.28.144.243]:9204 "HELO mail2.efacec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752776Ab2K1IjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 03:39:05 -0500
X-Greylist: delayed 768 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2012 03:39:04 EST
X-SMTPRelay-Internal: on
X-SMTPRelay-Data: addr=172.18.8.3, from=fernando.gomes@efacec.com
X-SMTPRelay-Id: 121128082517598000000 @ MAILOUT2
From: Fernando Gomes <fernando.gomes@efacec.com>
To: =?iso-8859-15?Q?An=EDbal_Almeida_Pinto?= <anibal.pinto@efacec.com>,
        =?iso-8859-15?Q?Jos=E9_Alexandre_Ventura?= 
	<jose.ventura@efacec.com>
CC: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        "John Kacur" <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.0.53-rt77
Thread-Topic: [ANNOUNCE] 3.0.53-rt77
Thread-Index: AQHNzRJkY2vgTEZ57UquECCDpZpYtpf+6cB3
Date: Wed, 28 Nov 2012 08:25:39 +0000
Message-ID: <qpoctfrhi1wdy2jpd299wj19.1354091136214@email.android.com>
References: <1354070691.6276.95.camel@gandalf.local.home>
In-Reply-To: <1354070691.6276.95.camel@gandalf.local.home>
Accept-Language: en-US, pt-PT
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nova release do rt sobre o 3.0.53, nao sei se nao valera a pena ver o que tem vindo a mudar, segundo este post nao sao alteracoes especificas do rt.

Abraco

Fernando

Steven Rostedt <rostedt@goodmis.org> wrote:


Dear RT Folks,

I'm pleased to announce the 3.0.53-rt77 stable release.


This release is just an update to the new stable 3.0.53 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 7399b1a4e535957c4ab7c07818e25433ac414d23


Or to build 3.0.53-rt77 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.53.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.53-rt77.patch.xz



Enjoy,

-- Steve



--
To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


