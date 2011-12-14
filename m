Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390Ab1LNXAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:00:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34638 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758361Ab1LNXAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:00:48 -0500
Message-ID: <4EE92A97.5080606@zytor.com>
Date: Wed, 14 Dec 2011 15:00:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 3/4] EFI: Add support for variables longer than 1024 bytes
References: <1323896791-10858-1-git-send-email-mjg@redhat.com> <1323896791-10858-4-git-send-email-mjg@redhat.com> <CAGTjWtCpt_1h6XMwCFkx1TQnQbagtSuFBejcp6XNr4yhKgNuLg@mail.gmail.com> <20111214223950.GA29264@srcf.ucam.org> <CAGTjWtARm_OA0qy2Cvtc-rrPFpH2+2QdFw4CvBAo-PJsfX6t6w@mail.gmail.com>
In-Reply-To: <CAGTjWtARm_OA0qy2Cvtc-rrPFpH2+2QdFw4CvBAo-PJsfX6t6w@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 02:57 PM, Mike Waychison wrote:
> 
> Well,l we could *not* support returning all the data field for
> datasize > 1024, and simply truncate the field.  We are limited by
> PAGE_SIZE by sysfs here anyway (so we don't really want to have a
> variable size memcpy in efivar_show_raw).
> 

That may be the biggest reason to avoid sysfs.  As far as I know sysfs
doesn't allow seq_file to be used.

	-hpa
