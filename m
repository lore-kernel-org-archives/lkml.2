Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378Ab0J1LQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:16:13 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53502 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab0J1LQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=jTPjMynfVioYmt50lF0RQ4SUVgxvhL2d9/bHdhfPlc+0R5kADwyB5b3k2x0NMW/Dvr
         hOvvJnU3W5VwgAqdLN2gVhlQWcYESDZOLhxpo1iaAYvt8GD15qefiZHPqcXBFJPt65xe
         2rZRRpGyK+iQyEWTfZhGTt+8vz3ZHCtT7isug=
MIME-Version: 1.0
In-Reply-To: <20101028090002.GA12446@elte.hu>
References: <AANLkTimt7wzR9RwGWbvhiOmot_zzayfCfSh_-v6yvuAP@mail.gmail.com>
	<AANLkTikRKVBzO=ruy=JDmBF28NiUdJmAqb4-1VhK0QBX@mail.gmail.com>
	<AANLkTinzJ9a+9w7G5X0uZpX2o-L8E6XW98VFKoF1R_-S@mail.gmail.com>
	<AANLkTinDDG0ZkNFJZXuV9k3nJgueUW=ph8AuHgyeAXji@mail.gmail.com>
	<AANLkTikvSGNE7uGn5p0tfJNg4Hz5WRmLRC8cXu7+GhMk@mail.gmail.com>
	<20101028090002.GA12446@elte.hu>
Date: Thu, 28 Oct 2010 14:16:11 +0300
X-Google-Sender-Auth: X9Y96HBfi5xEf26rwB2jrfDXw00
Message-ID: <AANLkTinoGGLTN2JRwjJtF6Ra5auZVg+VSa=TyrtAkDor@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg <penberg@kernel.org> wrote:
>> On Thu, Oct 28, 2010 at 9:09 AM, Aidar Kultayev <the.aidar@gmail.com> wrote:
>> > Find attached screenshot ( latencytop_n_powertop.png ) which depicts
>> > artifacts where the window manager froze at the time I was trying to
>> > see a tab in Konsole where the powertop was running.
>>
>> You seem to have forgotten to include the attachment.

On Thu, Oct 28, 2010 at 12:00 PM, Ingo Molnar <mingo@elte.hu> wrote:
> I got it - it appears it was too large for lkml's ~500K mail size limit.
>
> Aidar, mind sending a smaller image?

Looks mostly VFS to me. Aidar, does killing Picasa make things
smoother for you? If so, maybe the VFS scalability patches will help.

                        Pekka
