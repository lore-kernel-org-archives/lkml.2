Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab2DYXhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 19:37:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45958 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454Ab2DYXhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 19:37:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120422025532.GA19064@khazad-dum.debian.net>
References: <20120411163849.GE4794@alberich.amd.com> <4F8D7A0A.4080404@linux.vnet.ibm.com>
 <20120417145002.GA11221@aftab> <201204171153.04489.gene.heskett@gmail.com>
 <CAPXgP12_k4D-r=HQy3zidHhMP8ygMsT4J5Q+-h0CE3k_vpsazA@mail.gmail.com> <20120422025532.GA19064@khazad-dum.debian.net>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 26 Apr 2012 01:36:59 +0200
Message-ID: <CAPXgP12EVPwCDB0F8bHiApgb926AVhfZf0LiW-WzXVfb6ocN8w@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86, microcode: Ensure that module is only loaded for
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Gene Heskett <gene.heskett@gmail.com>, Borislav Petkov <bp@amd64.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        tigran@aivazian.fsnet.co.uk, hpa@zytor.com, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 04:55, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Tue, 17 Apr 2012, Kay Sievers wrote:

>> Just a note: the intel microcode is loaded by a kernel-initiated
>> firmware request these days. There is no (broken) init script on
>
> Is it?  Which distros have deployed the required userspace and switched to
> Intel binary microcode already?

The tool is here:
  http://pkgs.fedoraproject.org/repo/pkgs/microcode_ctl/intel-microcode2ucode.c/0efc5f6c74a4d7e61ca22683c93c98cf/intel-microcode2ucode.c

It's at least used here:
  http://pkgs.fedoraproject.org/gitweb/?p=microcode_ctl.git;a=tree
  https://build.opensuse.org/package/files?package=microcode_ctl&project=Base%3ASystem
  http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/sys-apps/microcode-data/files/

Kay
