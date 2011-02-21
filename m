Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab1BUDlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 22:41:12 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50740 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab1BUDlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 22:41:11 -0500
MIME-Version: 1.0
In-Reply-To: <20110220232808.GL15795@trinity.fluff.org>
References: <1297306314-11483-1-git-send-email-thomas@wytron.com.tw>
 <20110216043540.GB11684@angua.secretlab.ca> <20110220232808.GL15795@trinity.fluff.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 20 Feb 2011 20:40:49 -0700
X-Google-Sender-Auth: 6PUfkQTCM8XUafYlzhWEDiGmH8A
Message-ID: <AANLkTi=sQ2oS4qbfHtKG52KnDcpqkijQx_YXoAbctNzL@mail.gmail.com>
Subject: Re: [PATCH] i2c-ocores: register devices on child nodes
To: Ben Dooks <ben-i2c@fluff.org>
Cc: Thomas Chou <thomas@wytron.com.tw>, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 4:28 PM, Ben Dooks <ben-i2c@fluff.org> wrote:
> On Tue, Feb 15, 2011 at 09:35:40PM -0700, Grant Likely wrote:
>> On Thu, Feb 10, 2011 at 10:51:54AM +0800, Thomas Chou wrote:
>> > This patch registers devices on the devicetree child nodes to the bus.
>> > Also removes one trailing whitespace.
>> >
>> > Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
>>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>>
>> Ben, do you want to pick this one up?  Or should I merge it via my
>> devicetree branch?
>
> If it applies to the mainline kernel, then I'll take it.

It should apply to mainline no problem.

g.

>
> --
> Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/
>
> Large Hadron Colada: A large Pina Colada that makes the universe disappear.
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
