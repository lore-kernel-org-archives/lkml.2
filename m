Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab0IIMjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 08:39:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50195 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab0IIMjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 08:39:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SRLKX9+jxvO57eKhXyMUQ9EWjepHhbPIlqO9xfir6bBYnNxM7Ca114NR9booTlurFq
         vhyfLXONa9lQsqxUA9dpasH01uIujTlRoUVgtvXeDZNssaP8ZnIo8xx3hG9q9li8ScVD
         yU67PvJGaVUo4GRyEYojbK2DYHtqZBelScW0w=
MIME-Version: 1.0
In-Reply-To: <4C88AA27.5070206@mvista.com>
References: <064bb0722da5d8c271c2bd9fe0a521cc@localhost>
	<99a0868bdbcfa8785a92b4af4f6d9b99@localhost>
	<4C88AA27.5070206@mvista.com>
Date: Thu, 9 Sep 2010 05:39:32 -0700
Message-ID: <AANLkTinAhsetaV2F8SfBZE_BtaMhhmJO2fEwL+LJpZxB@mail.gmail.com>
Subject: Re: [PATCH 3/3] MIPS: DMA: Add plat_extra_sync_for_cpu()
From: Kevin Cernekee <cernekee@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 2:34 AM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
>> +static inline void plat_extra_sync_for_cpu(struct device *dev,
>> +       dma_addr_t dma_handle, unsigned long offset, size_t size,
>> +       enum dma_data_direction direction)
>> +{
>> +       return;
>
>   Why not just empty function bodies?

For consistency with plat_extra_sync_for_device().
