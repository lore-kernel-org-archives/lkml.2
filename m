Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0ILMix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 08:38:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57203 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0ILMiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 08:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Xgu5Dma4k3XGhQX6VHMnbBJWVeVlUL4qrFlob4DRkbMNRlPBtYT3Td2mZGVxi01e1G
         xjVUv9HWppA0LOdqubZIRJYguUr1otZfpzOa7lVBEeeix1X+WSSHXzr5HFHg+nZOnTAS
         gzrxmfbP5UtQ3PbLM3N6D+gQm8OiBBBhwBB68=
MIME-Version: 1.0
In-Reply-To: <20100527151515.GA3835@think>
References: <20100527151515.GA3835@think>
Date: Sun, 12 Sep 2010 15:38:50 +0300
Message-ID: <AANLkTik5mFPnqiUH3dkeGWnOz+PCBPx3rtiVzAQrXf75@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs updates
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Chris Mason <chris.mason@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 6:15 PM, Chris Mason <chris.mason@oracle.com> wrote:
>    Btrfs: Fix block generation verification race (+1/-1)

This seems to cause a hang when there are "parent transid verify failed" errors.

Somebody on #btrfs told me to revert it, and at least the system
doesn't hang any more.

-- 
Felipe Contreras
