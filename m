Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab1KJI2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:28:07 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53296 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab1KJI2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:28:05 -0500
MIME-Version: 1.0
In-Reply-To: <CA+1xoqe22z9F3ZyFG_XnV9Y17HtkeSxtf1gbW4+CW1cuNQ=N5g@mail.gmail.com>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
	<4EBB4A21.20707@codemonkey.ws>
	<alpine.LFD.2.02.1111100829560.1791@tux.localdomain>
	<m3pqh0tnoi.fsf@blackfin.pond.sub.org>
	<CA+1xoqe22z9F3ZyFG_XnV9Y17HtkeSxtf1gbW4+CW1cuNQ=N5g@mail.gmail.com>
Date: Thu, 10 Nov 2011 10:28:03 +0200
X-Google-Sender-Auth: NA5kY63Zq1FaZAkZ82wnH1Eergw
Message-ID: <CAOJsxLHxDGVrJ=yLpSRT+g+N0BPQhGOMufqHVxd3+A2HPxW-0A@mail.gmail.com>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
From: Pekka Enberg <penberg@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Markus Armbruster <armbru@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:23 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> I'm actually not sure why KVM tool got QCOW support in the first
> place. You can have anything QCOW provides if you use btrfs (among
> several other FSs).

To make it easy for people to use their existing images. I would love
to see native support for other image formats as well.

                        Pekka
