Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0DOIId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 04:08:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63201 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0DOIIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 04:08:30 -0400
Message-ID: <4BC6C977.1070407@0xlab.org>
Date: Thu, 15 Apr 2010 16:08:23 +0800
From: Matt Hsu <matt@0xlab.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: johnpol@2ka.mipt.ru
Subject: Why doesn't W1 sub system support UART implementation as bus master?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was managed to implement battery driver based on W1 protocol.
Its master bus is implemented by UART port. The driver status is almost 
done.
And I plan to send patches for upstream.

Before that, I would like to know why it's not yet supported UART port 
as bus master.
Are there considerations on this? Anything do I miss?

PS. please loop me in the mail thread.

Cheers,
Matt
