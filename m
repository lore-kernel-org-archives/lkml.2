Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1CVGb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 02:31:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab1CVGb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 02:31:56 -0400
Message-ID: <4D884250.3040302@redhat.com>
Date: Tue, 22 Mar 2011 14:31:44 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        Takao Indoh <tindoh@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Len Brown <lenb@kernel.org>, linux-doc@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Patch] acpi: introduce "acpi_addr=" parameter for kdump
References: <1299766243-494-1-git-send-email-amwang@redhat.com> <20110310143923.GB29464@redhat.com> <m1oc5ig90b.fsf@fess.ebiederm.org> <20110310185019.GB23105@srcf.ucam.org> <4D86F2C2.9080707@redhat.com> <m1hbawkifj.fsf@fess.ebiederm.org> <20110321155629.GF2694@redhat.com>
In-Reply-To: <20110321155629.GF2694@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年03月21日 23:56, Vivek Goyal 写道:
>
> Matthew and I were chatting in general about it couple of days back and
> mattew suggested how about if we embrace the idea of booting the kernel
> always in physical mode (both first and second) and keep that extra set
> of pagetables around to make EFI calls. That way kexec/kdump should just
> work and kernel changes also might not be too much.
>
> The potential problem with this is that this might expose various kind
> of BIOS issues with different vendors as vendors might not test the
> physical path.

First I have to say I know a little about EFI.

I am wondering what benefits we will lose if we use physical mode?
comparing it with virtual mode? If very few, this could be a solution.

Thanks.
