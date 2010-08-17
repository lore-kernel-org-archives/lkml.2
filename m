Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0HQFVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:21:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48754 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab0HQFVl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:21:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FgDzkVxik+EtlxMqFT8/Ev3oPx6ryPAPzkeIaUjvcNm7GZbF2x3kZkLuqBcyJktzgG
         vZUQhfArTaMswvoaHBdRyg/jhSejh6yIideYV94cDF6ENtEbYln8zJCddAEi7UGDVmsI
         1uZjllnurM9Wgnhr4Lp9qrvKhuwEkrQgH9XaM=
MIME-Version: 1.0
In-Reply-To: <4C6A1A2B.9080004@cn.fujitsu.com>
References: <AANLkTimDmwmC3xDJVXB1LXJzMJTuamCswVeC5v42zU-Q@mail.gmail.com>
	<4C69F7B9.2000103@cn.fujitsu.com>
	<AANLkTi==O7cKcM19iO=7XoZo3PndPBDctPy08NrbYSxx@mail.gmail.com>
	<4C6A1A2B.9080004@cn.fujitsu.com>
Date: Tue, 17 Aug 2010 05:21:39 +0000
Message-ID: <AANLkTinPq+=XvG283cQC2S4qRtvvqAaKVqdA4dDy1NVN@mail.gmail.com>
Subject: Re: BUG: nconfig doesn't preserve case in its menu display
From: =?UTF-8?B?w4Z2YXIgQXJuZmrDtnLDsCBCamFybWFzb24=?= <avarab@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Linux is full of bugs <linux-kernel@vger.kernel.org>,
        Nir Tzachar <nir.tzachar@gmail.com>, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 05:12, Li Zefan <lizf@cn.fujitsu.com> wrote:

> Oops, I made a mistake. Try this one:

Thanks, that works.

Tested-by: Ævar Arnfjörð Bjarmason <avarab@gmail.com>
