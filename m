Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab0KFWQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 18:16:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39157 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab0KFWQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 18:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=WqJL6mlt066eYSpPrXtL7NhkVw2Rjs8GaNZaSestamN0jU5WekUzlKtR6vk6VBTVBC
         SE2odep7UBQY1KNjSaKi/p8gExBlZNNgh7Y8e4ImNtlaSGJbMBhegYOPn6ox9jVWa+gq
         M1OW3Txqjf4isQXtsmsgzyueonCs+eqhMfXHE=
MIME-Version: 1.0
Date: Sat, 6 Nov 2010 23:16:11 +0100
Message-ID: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
Subject: [PATCH] DM-CRYPT: Scale to multiple CPUs v3 on 2.6.37-rc* ?
From: Matt <jackdachef@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

before diving into testing out 2.6.37-rc* kernels I wanted to make
sure that the patch:

[dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3

is safe to use with e.g. >2.6.37-rc1 kernels

I know that it's not a "fix all" patch but it significantly seems to
speed up my backup jobs (by factor 2-3)
and 2.6.37* has evolved that much that interactivity isn't hurt too much

Thanks !

Matt
