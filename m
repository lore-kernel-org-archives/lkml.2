Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1DRSbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 14:31:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55082 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab1DRSbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 14:31:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NFBT5bhFjHnqw4a6Q3J6/r6UXHFjvy8X7kcyI3csLhL87HGJ4z2s9/zkR7zRBV+ON4
         UDxTd3K8d03kv0x1l0tg==
MIME-Version: 1.0
In-Reply-To: <1302924445-18557-1-git-send-email-sonnyrao@chromium.org>
References: <1302924445-18557-1-git-send-email-sonnyrao@chromium.org>
Date: Mon, 18 Apr 2011 11:31:09 -0700
X-Google-Sender-Auth: 91Yra2_ntMkS4zlXBRX8zqUcUUM
Message-ID: <BANLkTikwJzOXJGM4pcKmxVdP_2yb9uyeag@mail.gmail.com>
Subject: Re: [PATCH] Fix infinite loop in ARM user perf_event backtrace code
From: Olof Johansson <olofj@chromium.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Jamie Iles <jamie@jamieiles.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 8:27 PM, Sonny Rao <sonnyrao@chromium.org> wrote:
>
> The ARM user backtrace code can get into an infinite loop if it
> runs into an invalid stack frame which points back to itself.
> This situation has been observed in practice.  Fix it by capping
> the number of entries in the backtrace.  This is also what other
> architectures do in their backtrace code.
>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
