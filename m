Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2E2XeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 19:34:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60181 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab2E2Xd6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 19:33:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo44TViNFcZivjr5hAu8w8kpEpUjxNAWtazhAqwwsorZbw@mail.gmail.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
	<1337754877-19759-3-git-send-email-yinghai@kernel.org>
	<CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com>
	<CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
	<CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
	<20120525043651.GA1391@google.com>
	<CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
	<CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com>
	<20120525193716.GA8817@google.com>
	<CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com>
	<CAErSpo7d+zn-qgWKcbro7yneXRtmZQCOHi+kiGzYUTfs+aiF4g@mail.gmail.com>
	<CAE9FiQUWWO75WP3gYRwYbyO_ZiWwyjKnzMxOGhfjY4H98w2Hbw@mail.gmail.com>
	<CAErSpo46fCCFCijNfMzGYP__pP6hkPFurMS=1=wSAZsg5z0-Lg@mail.gmail.com>
	<CAE9FiQWUrkKEpLmEn9kzkKOtEtX7-R8shdVSKGgSyHezKpzJCw@mail.gmail.com>
	<4FC50E09.4000204@zytor.com>
	<CAE9FiQUtio=dut3A9+jCcsgUWEeNYcpqLP6RpqGOZUfPPAtHWw@mail.gmail.com>
	<CAErSpo4ywho4UmPVAjT7yZNROc9e1zCx+UoaS5un+v4aN=akJA@mail.gmail.com>
	<CAE9FiQWORRjxEQwr+933ReNAAKAEoJ5B6AWte4gr33_BO+4heQ@mail.gmail.com>
	<CAErSpo44TViNFcZivjr5hAu8w8kpEpUjxNAWtazhAqwwsorZbw@mail.gmail.com>
Date: Tue, 29 May 2012 16:33:58 -0700
X-Google-Sender-Auth: oMdvHtkv4Gpzsx_lPSsR9IR3lyI
Message-ID: <CAE9FiQWmXLV4QsPP3Zab4iFogh1Lb6hxOwc8YnGyE5uTmwxB6Q@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 4:27 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> I don't understand this one at all.  It looks like you mashed together
> at least two changes: (1) prefer I/O space above 64K if available, and
> (2) mark secondary bus resources with IORESOURCE_IO_32 when the P2P
> bridge I/O window address decode type is PCI_IO_RANGE_TYPE_32 and use
> that to limit allocations.

let drop the one about IORESOURCE_IO_32.

that should only fix one reallocation bug in theory out of x86.

Thanks

Yinghai
