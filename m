Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab2AQAVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 19:21:44 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53047 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2AQAVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 19:21:42 -0500
MIME-Version: 1.0
In-Reply-To: <20120117001548.GA6884@suse.de>
References: <20120116224028.GA5072@suse.de> <20120117001403.GC18875@dztty> <20120117001548.GA6884@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 16:21:20 -0800
X-Google-Sender-Auth: BNl6GyhzNIFja5gVvnNR1i7hFUw
Message-ID: <CA+55aFzCsRM-w3JY13VUxmbZYGKAs0qrFS28QjHsTW9+5BuZJQ@mail.gmail.com>
Subject: Re: [PATCH] mce: fix warning messages about static struct mce_device
To: Greg KH <gregkh@suse.de>
Cc: Djalal Harouni <tixxdz@opendz.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sergei Trofimovich <slyich@gmail.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        Ming Lei <tom.leiming@gmail.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>, justinmattock@gmail.com,
        Jeff Chua <jeff.chua.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 4:15 PM, Greg KH <gregkh@suse.de> wrote:
>
> Linus, do you want to take this directly from the email, or do you want
> me to put it in a tree to pull from?

Do you have anything else pending before I close the merge window? If
so, put it in a tree with those.

If not, let me know, and I'll just take the patch as-is.

                  Linus
