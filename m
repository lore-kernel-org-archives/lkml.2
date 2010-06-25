Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab0FYI0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 04:26:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:34569 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0FYI0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 04:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Aa1nsAUdPOEe11MkqX+5GrsNvTTCziFTuafClStvjtgMtdB32ubaYQjUTZ5lp9J00y
         3bLDoL4S0nMvM9oB+tDQ6Q1k9ahuIRAjYTKiottpBOQ1BqaiCSXvyMq7VQCj6F20NxIl
         MG8VWYDeCNi5AhTM/vn4/5gJ0loRvoQ6cXAWY=
MIME-Version: 1.0
In-Reply-To: <4C23FF28.4040404@jp.fujitsu.com>
References: <4C2312A8.9060903@jp.fujitsu.com>
	<4C23FF28.4040404@jp.fujitsu.com>
Date: Fri, 25 Jun 2010 09:57:27 +0200
Message-ID: <AANLkTil3-HcxDwzTEJZ3csmV_kjCo7JS5gOvZIkmoHk9@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/5] napi: convert trace_napi_poll to TRACE_EVENT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com,
       izumi.taku@jp.fujitsu.com,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/25 Koki Sanagi <sanagi.koki@jp.fujitsu.com>:
> This patch converts trace_napi_poll from DECLARE_EVENT to TRACE_EVENT.


>From DECLARE_TRACE to TRACE_EVENT.

Or more generally: this expands the napi polling tracepoint to a trace
event, to improve the
napi polling tracepoint usability.


> This lets you know how long napi_poll takes.
>
>          <idle>-0     [001] 241302.750777: napi_poll: napi poll on napi struct f6acc480 for device eth3
>          <idle>-0     [000] 241302.852389: napi_poll: napi poll on napi struct f5d0d70c for device eth1
>          <idle>-0     [000] 241302.852389: napi_poll: napi poll on napi struct f5d0d20c for device eth1
>
> This is a same patch Neil Horman submitted.
> http://marc.info/?l=linux-kernel&m=125978157926853&w=2

Hmm, nope, doesn't seem to be the same patch.
