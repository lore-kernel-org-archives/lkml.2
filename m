Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1BQBFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:05:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62417 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab1BQBF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:05:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=FCgd2AURJ51QQmZFq/8g1WvyQdROxMlggypR3icGizpOd8+7wR/QIhdW1GEdqky3Rg
         pSlrjD4fnciIqxJWTTI9dTDEusA8M392nQifTDA35UQTFW8a3Byo7WdfRPPvi6FSEqnF
         ssv5osawLmHsXhvjbzUqba3iI3cRfGlNopesM=
MIME-Version: 1.0
In-Reply-To: <20110216.165657.226784086.davem@davemloft.net>
References: <AANLkTinzr6rb=WwFs7QApsvdy5f7PHZ1qS9ZVrncEzZD@mail.gmail.com>
 <20110216225151.GA10435@ele.uri.edu> <20110217005300.GM5818@one.firstfloor.org>
 <20110216.165657.226784086.davem@davemloft.net>
From: Michael Witten <mfwitten@gmail.com>
Date: Wed, 16 Feb 2011 19:04:52 -0600
Message-ID: <AANLkTi=3q4vwd=3xMHARqd02euePhOS-K37HmywD3qJh@mail.gmail.com>
Subject: Re: Please watch your cc lists
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, simoneau@ele.uri.edu, will.newton@gmail.com,
        rostedt@goodmis.org, hpa@zytor.com, matt@console-pimps.org,
        peterz@infradead.org, jbaron@redhat.com, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 18:56, David Miller <davem@davemloft.net> wrote:
> Well, Andi, since you removed the subject nobody has any idea
> what thread you are even referring to.

However, all of the necessary information is in the email headers:

    In-Reply-To: <20110216225151.GA10435@ele.uri.edu>

    References: <4D59B891.8010300@zytor.com>
      <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
      <20110215211123.GA3094@ele.uri.edu>
      <20110215.132702.39199169.davem@davemloft.net>
      <20110215215604.GA3177@ele.uri.edu>
      <AANLkTikXy+AJ3tdEkEN--xJPefbXJ4-OVS3cg6R7yXzc@mail.gmail.com>
      <1297858734.23343.138.camel@gandalf.stny.rr.com>
      <AANLkTinzr6rb=WwFs7QApsvdy5f7PHZ1qS9ZVrncEzZD@mail.gmail.com>
      <20110216225151.GA10435@ele.uri.edu>

It's a damn shame that our email tools ignore such useful information.
