Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0IBRtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:49:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60962 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab0IBRtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=RGjBPo5QdeYXDn5kh20lN1n6c1lt0gnB1pgcxxbyWS0qTKt+/V1om8u89dhO5h4xOQ
         jsN9QiQOXYyjBk7B3yi7LIG9dpm7s2yH+Q6jwghzzjLMXNV1hEZtcGPsYcJVxx2FYvWq
         KPkM9eidwh25GPaK5u7TZD23Mvk9kcBNJV1Bo=
MIME-Version: 1.0
In-Reply-To: <1283442391-23612-8-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com> <1283442391-23612-8-git-send-email-namhyung@gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 2 Sep 2010 13:48:49 -0400
X-Google-Sender-Auth: Vozg6Ahf2TJljnQZH3Tg46w1-T0
Message-ID: <AANLkTimqZ_wzGuudhgf7LsMgZou_xSDg=Qo4BsnXnBPp@mail.gmail.com>
Subject: Re: [PATCH v2 07/24] ptrace: cleanup arch_ptrace() and friends on Blackfin
To: Namhyung Kim <namhyung@gmail.com>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 11:46, Namhyung Kim wrote:
> Change signature of get/put_reg() according to the change of arch_ptrace()
> and remove unnecessary castings.

thanks; Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
