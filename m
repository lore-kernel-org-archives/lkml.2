Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1AFW2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:28:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35034 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab1AFW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:28:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=f5bHt0gjvxFOnjVYY88wzqcS2rzborr/igUkxXz9isdwT/UkQc4gEa4mL2q+Z25aAO
         KaUGo7nWMFjO1fPpjtYEQF0J+hrXzb2RHK1M4TLDcqbx3VlDjnB0DO8qOjL1Z2YnAyOa
         cmbQXkiUBbS8Q2Z4zM8Dkzul9L3i96Nz+m5zU=
MIME-Version: 1.0
In-Reply-To: <AANLkTik7tcZo8ka80y=FD-_UxwvB6-R8iRHRq+rkOSo+@mail.gmail.com>
References: <20110106094423.GA17565@elte.hu>
	<AANLkTinU423YzQxB9y7ZM9GQAYPQyTJUm9w18=6P_F88@mail.gmail.com>
	<4D26166D.1020009@zytor.com>
	<AANLkTik7tcZo8ka80y=FD-_UxwvB6-R8iRHRq+rkOSo+@mail.gmail.com>
Date: Thu, 6 Jan 2011 14:27:59 -0800
X-Google-Sender-Auth: 0R0OPif_O-25tnM2mjqe2NQec14
Message-ID: <AANLkTinakrwszoiV9qv3QTpUa0-gt600pn3dg2Cv7H=L@mail.gmail.com>
Subject: Re: [GIT PULL] x86/apic changes for v2.6.38
From: Tony Luck <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Taking a slight tangent ... it would seem that nr_cpus/maxcpus are woefully
inadequate on NUMA systems. If I have a four node NUMA machine and
I boot with maxcpus=4 ... I probably want one cpu on each node. I might
want all four of the cpus from the same node (so I can check memory
allocation from cpu-less nodes?). What I almost definitely don't want is
the first four cpus that the BIOS listed in the MADT (which could be
scattered in any way across nodes).

-Tony
