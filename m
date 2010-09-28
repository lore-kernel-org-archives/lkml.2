Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab0I1Qaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:30:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716Ab0I1Qae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:30:34 -0400
Message-ID: <4CA21820.5010704@redhat.com>
Date: Tue, 28 Sep 2010 18:30:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Alexander Graf <agraf@suse.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] x86, nmi: workaround sti; hlt race vs nmi; intr
References: <1284913699-14986-1-git-send-email-avi@redhat.com> <4CA057EA.7000609@redhat.com> <768A5DC0-131A-4BC8-ADDD-044D8169545E@suse.de> <61284934-1AD3-4F7A-9488-D46FCEE9B753@suse.de> <4CA06147.7080805@redhat.com> <C725B379-9631-46E4-A825-E43A5120681E@suse.de> <4CA06373.5030501@redhat.com> <4CA112D1.2020004@zytor.com> <4CA1AC50.7000801@redhat.com> <4CA20B21.7060809@zytor.com>
In-Reply-To: <4CA20B21.7060809@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/28/2010 05:34 PM, H. Peter Anvin wrote:
> On 09/28/2010 01:50 AM, Avi Kivity wrote:
> >
> >  Personally I think the safer route is to take the patch.  There are
> >  other processors besides Intel and AMD and we can't test all of them,
> >  not to mention various emulators and virtual machine monitors out there.
> >
>
> Speaking for the smoltering crater that used to be *Transmeta*, I'm
> (from memory) quite certain they blocked NMI and that this was
> intentional behavior.
>

We'll need:

- Intel
- AMD
- Geode
- Via
- kvm (currently no, but plan to)
- qemu
- vmware
- others?

It should be relatively simple to write a small test case to test this.

-- 
error compiling committee.c: too many arguments to function

