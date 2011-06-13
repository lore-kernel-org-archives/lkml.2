Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1FMRF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:05:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48727 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab1FMRFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:05:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NiWpJkhZFFQ4p4aDEhZlG0oP67APOs8ALz2WKImr1aOusArSEVpwQlWGJM/sJ+uoo3
         A8xHgpweD1uHFJX9GM4O0YATwXwgI/9BeH+tHWGNXo1qDqe48bTYT+PuFFrRyLOCxeBc
         5v0EfHCADHQEZ8fRUppLsjkh70S156YVz2/vc=
MIME-Version: 1.0
In-Reply-To: <BANLkTik=t+BC4uBzXac-Gn7RjhmrnbWX6g@mail.gmail.com>
References: <BANLkTik=t+BC4uBzXac-Gn7RjhmrnbWX6g@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 13 Jun 2011 10:05:34 -0700
Message-ID: <BANLkTiknNdznxtn11NG3Z4EEpuFc08Pzmg@mail.gmail.com>
Subject: Re: [ANN] acs: automatic channel selection utility for 802.11
To: linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Bitterli <fbitterli@atheros.com>
Cc: linux-kernel@vger.kernel.org, hostap@lists.shmoo.com,
        Matt Smith <Matt.Smith@atheros.com>,
        Arun Venkataraman <arun.venkataraman@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 5:19 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

>                    (busy time - tx time)
>    int_factor = ------------------------- *  3^(noise + min_noise)
>                   (active time - tx time)

Switching to a coefficient of 2 instead of 3 for the noise multiplier
to reflect the way power in "far-field" radiation decreases as the
square of distance from the antenna [1]. Thanks to Felix Bitterli for
the hint.

[1] http://en.wikipedia.org/wiki/Near_and_far_field

  Luis
