Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2BARhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:37:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65399 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab2BARhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:37:13 -0500
Date: Wed, 1 Feb 2012 21:37:09 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: bq27x00_battery status report issue
Message-ID: <20120201173709.GB12255@oksana.dev.rtsoft.ru>
References: <CANOLnONB5m5iNbWy1=7WWN7T76S1vACbWtJu+KGyhqw2-cA3sw@mail.gmail.com>
 <10055259.ygSgKeUM8f@pali>
 <CANOLnOOAwyM=Egzr_S8pUa=6iM=q8TU8jRJW_5nVrgqtqLHGxw@mail.gmail.com>
 <3483637.Dq3EujObBh@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3483637.Dq3EujObBh@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 02:38:08PM +0100, Pali Rohár wrote:
> On Friday 20 January 2012 13:02:46 Grazvydas Ignotas wrote:
> > On Thu, Jan 19, 2012 at 12:56 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> > > Now I do not have device with bq27500 chip for testing. I read datasheet
> > > again and I think that your interpretation may be correct. Can you write
> > > patch for this problem and test it?
> > 
> > What about just reverting 270968c0984ae instead? I think my patch
> > would look almost exactly like that..
> 
> Ok, then revert this commit.

Reverted in battery-urgent.git, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
