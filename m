Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab1FMRu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:50:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab1FMRuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:50:55 -0400
From: Tom Tromey <tromey@redhat.com>
To: Hui Zhu <teawater@gmail.com>
Cc: gdb@sourceware.org, linux-kernel@vger.kernel.org
Subject: Re: Get new GDB for UBUNTU from launchpad PPA
References: <BANLkTinNKg1KMB13DChOc7E9uQ+f6mZXAg__49737.4360370033$1307196746$gmane$org@mail.gmail.com>
X-Attribution: Tom
Date: Mon, 13 Jun 2011 11:50:30 -0600
In-Reply-To: <BANLkTinNKg1KMB13DChOc7E9uQ+f6mZXAg__49737.4360370033$1307196746$gmane$org@mail.gmail.com>
	(Hui Zhu's message of "Sat, 4 Jun 2011 22:11:22 +0800")
Message-ID: <m3lix5sjrt.fsf@fleche.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> ">" == Hui Zhu <teawater@gmail.com> writes:

>> 3.  The package is named "gdb-7.3" and "gdb-trunk", and the GDB that
>> installed to the system is named "gdb-7.3" and "gdb-7.3.5".  So it
>> will not affect the GDB that you install in before.  You can use the
>> old one directly if you got some trouble with the new one.

I think it is a mistake to call it "7.3" -- a version which has not been
released.

Distros that ship modified or early releases modify the --version output
to show something different, e.g.:

    opsy. gdb --version
    GNU gdb (GDB) Fedora (7.1-34.fc13)

Please do the same with your releases.

Tom
