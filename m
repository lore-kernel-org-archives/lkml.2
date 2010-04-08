Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675Ab0DHUuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:50:32 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:48639 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933234Ab0DHUu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FAKV7ZU1aG6OONnQrT4sXk3ssmwUnQIgdARP4Smr5u3B8qVfih94o1olyKIUmvjzjC
         EqJxjhaOtsimLtPVWrW8AR6ZkqKQUwdw7oMq3+F9d48dAxd0dOF+HYktBelA3/V0m2ZL
         RAhX9ldjGGkTv1ohz9fuxUNBNSZsb5Oafchog=
MIME-Version: 1.0
In-Reply-To: <o2w12c511ca1004080919pa73e0552mec30ca706d9277a9@mail.gmail.com>
References: <20100408131251.b69e2fa2.sfr@canb.auug.org.au>
	 <alpine.DEB.2.00.1004080452150.11948@skynet.skynet.ie>
	 <20100408141423.82e04416.sfr@canb.auug.org.au>
	 <o2w12c511ca1004080919pa73e0552mec30ca706d9277a9@mail.gmail.com>
Date: Thu, 8 Apr 2010 23:50:26 +0300
Message-ID: <i2m548cdfc21004081350o2ba0ad71v23a10ab4c2156e0c@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the drm tree
From: Pauli Nieminen <suokkos@gmail.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Airlie <airlied@linux.ie>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 7:19 PM, Tony Luck <tony.luck@gmail.com> wrote:
> Does anyone else see:
>
> drivers/gpu/drm/ttm/ttm_page_alloc.c: In function ‘ttm_page_alloc_debugfs’:
> drivers/gpu/drm/ttm/ttm_page_alloc.c:830: error: implicit declaration
> of function ‘seq_printf’
>
> when building the next-20100408 tag?
>
> -Tony
>

http://marc.info/?l=dri-devel&m=127067975811418&w=2
