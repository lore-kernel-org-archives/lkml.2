Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597Ab0J2AP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 20:15:57 -0400
Received: from smtp-out.google.com ([74.125.121.35]:24174 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab0J2APx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 20:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jKvQY4cmuYzmNdiapWv5Ni42OmH8bbYEPZelNfhMq0YO7sabBlijNxGh4DN4K8MTVo
         VBYf+ZLrJkbIJlVjln6w==
MIME-Version: 1.0
In-Reply-To: <AANLkTinbtLkF=haFeDkzecEWv_FE9jG4TefiptSnZcPi@mail.gmail.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
	<4CC14769.2000406@cn.fujitsu.com>
	<AANLkTinbtLkF=haFeDkzecEWv_FE9jG4TefiptSnZcPi@mail.gmail.com>
Date: Thu, 28 Oct 2010 17:15:50 -0700
Message-ID: <AANLkTin+82ZMmTGEDY+w3pZgRgJ5HvjuLzwGxpcSdOUN@mail.gmail.com>
Subject: Re: [PATCH 7/7] cgroups: Update documentation for bindable subsystems
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 5:13 PM, Paul Menage <menage@google.com> wrote:
>
> Also, post_clone() doesn't get called when creating the css hierarchy
> during binding.
>

Oops, ignore that - I noticed that it does.

Paul
