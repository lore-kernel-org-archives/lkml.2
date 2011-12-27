Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab1L0LP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 06:15:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50551 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1L0LP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 06:15:56 -0500
MIME-Version: 1.0
In-Reply-To: <20111222125639.360640574@openvz.org>
References: <20111222125639.360640574@openvz.org>
Date: Tue, 27 Dec 2011 15:15:55 +0400
X-Google-Sender-Auth: p7Qr-vQJG9i8PRPeXvFfepKOJls
Message-ID: <CAM5jBj6-1Mbj+p-RY7JuA=26JcxKdw64B_+A7XRJ+3V_x5vrQA@mail.gmail.com>
Subject: Re: [patch 0/4] kernel generic object IDs series
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 4:56 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> Hi,
>
> when we do the checkpoint-restore we need to find out if various kernel objects
> (like mm_struct-s of file_struct-s) are shared between tasks (and restore them
> after).
>
...

Ping, any opinions on the series?
