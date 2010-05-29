Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0E2AEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 20:04:46 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36370 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab0E2AEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 20:04:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XU11PWNEuwUwQRunq+Jrhveb0jOxccihRM3nbZCRoCFSh51XXIBZEy8H2Ftu0fiQ0/
         gHjGftlBT1n5ejK3XS1WvTN6NbeQxWegpcWKIyxSTfzfMVxQJO+iQ+HMozbhUwJ/vcg5
         TgprMQmShrAXopPpOkLJGp7draBL39Xz/oSx4=
Message-ID: <4C005A19.8060806@gmail.com>
Date: Fri, 28 May 2010 18:04:41 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jack <mylinux.list@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Drivers for USB,SATA and eMMC
References: <AANLkTil0b9y0PJd4_eUS-M16Ya3yt1i7xzaOaGmA_cZ2@mail.gmail.com>
In-Reply-To: <AANLkTil0b9y0PJd4_eUS-M16Ya3yt1i7xzaOaGmA_cZ2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2010 05:46 AM, Jack wrote:
> I have a new IOH which is connected to an x86 core through PCIe. This
> IOH has SATA, USB and eMMC attached to it.. Do I need to write a
> controller driver (referring the IOH data sheet) for these interfaces,
> or does Linux provides any std. drivers for these interfaces. I am new
> to x86 stuffs.
> Could anyone guide me on this.?

It depends what interface protocol those devices use..
