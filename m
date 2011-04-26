Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1DZMzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:55:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50945 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab1DZMzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:55:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IQ0iP+thZYaXYdmn46Sn8MoFTJ3qe8X14eYS8os0Ub/ODRd3nw0p1FqIkZoDneiAnP
         OzPHvyuLFlkMoV5hmvHpM3IPRAx6lR/L0blNKBjC6sAfbnjogjhshHNBmXUSeqIzXsDR
         ufAloxvB7s7395X2yQKCzlE2STaXsKVRHuFbs=
MIME-Version: 1.0
In-Reply-To: <201104261437.53925.arnd@arndb.de>
References: <BANLkTimaJFFCCQOA6=G4i95PsJK_S2bf9Q@mail.gmail.com>
	<201104261437.53925.arnd@arndb.de>
Date: Tue, 26 Apr 2011 15:55:07 +0300
Message-ID: <BANLkTimo32+QbU9orRNS8StCmRsF_9MVGQ@mail.gmail.com>
Subject: Re: Why is the 'loff_t *offset' parameter in the file_operations'
 read function a pointer?
From: Amit Ben Shahar <amit.bens@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The read function must update the offset independent of the return value.
> See simple_read_from_buffer() as an example.

Thank you - that helped greatly and solved my problem.
Amit.
