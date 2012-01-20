Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab2ATLCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 06:02:49 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57820 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460Ab2ATLCs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 06:02:48 -0500
MIME-Version: 1.0
In-Reply-To: <10055259.ygSgKeUM8f@pali>
References: <CANOLnONB5m5iNbWy1=7WWN7T76S1vACbWtJu+KGyhqw2-cA3sw@mail.gmail.com>
	<10055259.ygSgKeUM8f@pali>
Date: Fri, 20 Jan 2012 13:02:46 +0200
Message-ID: <CANOLnOOAwyM=Egzr_S8pUa=6iM=q8TU8jRJW_5nVrgqtqLHGxw@mail.gmail.com>
Subject: Re: bq27x00_battery status report issue
From: Grazvydas Ignotas <notasas@gmail.com>
To: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 12:56 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> Now I do not have device with bq27500 chip for testing. I read datasheet again
> and I think that your interpretation may be correct. Can you write patch for
> this problem and test it?

What about just reverting 270968c0984ae instead? I think my patch
would look almost exactly like that..


-- 
Gražvydas
