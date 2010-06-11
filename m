Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab0FKAuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 20:50:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57688 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab0FKAuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 20:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=L0X6ej+f1zHlGSmD3PnDQZx0IVZny1u4pKVAJ6aGYr1Dts5Ka5y1YCLNN7bwiJxZQe
         khM7BZ400RjayBl1ns9TZzrcssAdLhWr0QvPaAOPUJHKgG8zzF0B+YBNcohag/qOScTf
         EriUDnmoi/X58UO04cV/0qH8T4aiyATQ0VLjk=
Message-ID: <4C118844.2020401@gmail.com>
Date: Thu, 10 Jun 2010 18:50:12 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Yedire, Sandeep" <syedire@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: O_NONBLOCK with Ext2/3
References: <AANLkTimVgcnvb-obG4As0jjZQk6rwsHd-ByrfL4KxP0A@mail.gmail.com>
In-Reply-To: <AANLkTimVgcnvb-obG4As0jjZQk6rwsHd-ByrfL4KxP0A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 06:44 AM, Yedire, Sandeep wrote:
> Hi All,
> What is the effect  on filesystem blocks,data blocks if O_NONBLOCK
> flag is used with a test application doing write to a file(64MB) on
> NAND Flash.
> Can any one please let me know
> Regards,
> Sandeep.Yedire

O_NONBLOCK doesn't do anything on regular files, as far as I'm aware. 
It's only useful on sockets, serial ports/TTYs, etc.
