Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab1D3SAs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 14:00:48 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58459 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1D3SAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 14:00:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=C+g1goOzYXDW/koaBdiR9LiU596iXk/Nr1Dl7qxU0bYJ8iuVGiXKh9oF6lOgSmgEFF
         T1WR+1I71NRTe66WJ/jkZP63uYyyxuTmtJCHaKNNuQ9U+BpqUo0eZ/lJIhzuAyNmwe/5
         GEEsh05WMSj8IPbZD5jlvGvBKzm0i3wIDUxoc=
MIME-Version: 1.0
In-Reply-To: <4DBC37D0.3070408@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
	<1304090924-8197-9-git-send-email-tj@kernel.org>
	<4DBAF498.40007@kernel.org>
	<20110430120307.GE29280@htj.dyndns.org>
	<4DBC37D0.3070408@kernel.org>
Date: Sat, 30 Apr 2011 20:00:44 +0200
X-Google-Sender-Auth: VTKCfYBPbY3j2rFbEyE7_MVB-p4
Message-ID: <BANLkTimaDnFZbSAitJOPdKb2fuuHKS0HpQ@mail.gmail.com>
Subject: Re: [PATCH 08/25] x86, NUMA: trivial cleanups
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Apr 30, 2011 at 6:24 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> I posted two patches for
> Kill no longer used struct bootnode.
> Make setup_node_bootmem() static

Ah, okay.  Do you mind resending them to me?  I'll integrate it with
the patchset.

> Also setup_node_bootmem now is some misleading, could change to setup_node_data() ?

Sure, I don't like the current name either.  Do you mind sending a
patch for that too?

Thanks.

-- 
tejun
