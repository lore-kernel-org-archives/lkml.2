Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161185Ab2GLO2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:28:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55278 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161113Ab2GLO2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:28:32 -0400
Date: Thu, 12 Jul 2012 16:28:28 +0200
From: Stevie Trujillo <stevie.trujillo@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org
Subject: mount -o loop with truncated dosdisk.img uses 100% cpu and can't be
 killed
Message-ID: <20120712162828.3f561315@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was trying to create a bootdisk to update my BIOS, and accidentially
made a 512byte image with only the FreeDOS header in it.

( Linux 3.4.4 )
# mount -o loop dosdisk.img /tmp
^C^C^C
It uses 100% CPU and doesn't listen to me when I do ^C, kill -9 etc. I
think this means it's stuck in the kernel?

Here is the base64 encoded image (use base64 -d command to unpack it).
6zyQRnJlZURPUyAAAgEBAALgAEAL8AkAEgACAAAAAAAAAAAAAAApOATF6E5PIE5BTUUgICAgRkFU
MTIgICD6/DHAjti9AHy44B+OwInuie+5AAHzpepefOAfAABgAI7YjtCNZqD7gH4k/3UDiFYkx0bA
EADHRsIBAOjpAEZyZWVET1MAi3Yci34eA3YOg9cAiXbSiX7UikYQmPdmFgHGEdeJdtaJftiLXgux
BdPri0YRMdL384lG0AHGg9cAiXbaiX7ci0bWi1bYi37QxF5a6JsAci/Eflq5CwC+8X1X86ZfJotF
GnQLg8cgJoA9AHXncllQxF5ai34Wi0bSi1bU6GsAWHJGHgeOXly/ACCricYB9gHG0e6tcwSxBNPo
gOQPPfgPcugxwKsOH8ReWr4AIK0JwHQkSEiLfg2B5/8A9+cDRtoTVtzoJABz5egXACBlcnIAMOTN
Fs0Zil4k/25aMdu0Ds0QXqxWPAB188NWiUbIiVbKjEbGiV7EtEG7qlWKViSE0nQZzRNyFdHpgdtU
qnUNjXbAiV7MiV7OtELrLItOyItWyopGGPZmGpH38ZL2dhiJ0YjGhunQydDJikYYKOD+xAjhxF7E
uAECilYkzRNzBjDkzRProotGC/Z2wAFGxoNGyAGDVsoAT3XqjkbGXsNLRVJORUwgIFNZUwAAVao=

--
Stevie Trujillo
