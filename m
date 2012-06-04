Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab2FDBZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 21:25:00 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57115 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2FDBY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 21:24:59 -0400
Message-ID: <4FCC0E6D.9000206@gmail.com>
Date: Mon, 04 Jun 2012 05:25:01 +0400
From: George Shuklin <george.shuklin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Why minor is still 8 bit?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've understand that major and minor numbers for device is 8-bit size.

I've don't understand, WHY? In 2012!

(I've just have some discussion about 8-bit counter limitations in 
context of cloud computing. In middle of 2012!!!!)

But seriously, I've done some googling but found no answer why it still 
just 8 bit size. Is this some serious backward compatibility? Or just 
there is no one with itch strong  enough?
