Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab1BDMxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:53:54 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41564 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1BDMxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:53:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N6iCt2gsoVW2/ZBY5CrWtix7K7XvQa6NO+XxlgDv3C299AMnZbX7F5ppFyMbNQlAej
         EolpOZtcsbAvj166x5p6MamMXWOflrjdlvrM/Z3E5SYEBf9xyKAG2TiHeRmKKeQGwEwl
         RLRQG82rKP72UgC+dTlvMa1WZ4xoiCKcCGoPM=
MIME-Version: 1.0
In-Reply-To: <59f50c896fa91e8b7822c71800c76063b0b58d2b.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
	<59f50c896fa91e8b7822c71800c76063b0b58d2b.1296818921.git.segoon@openwall.com>
Date: Fri, 4 Feb 2011 12:53:48 +0000
Message-ID: <AANLkTinZjaNJX040OOE+Fg2k_zNEiQ--BhTa91oAx2Z_@mail.gmail.com>
Subject: Re: [PATCH 15/20] platform: x86: asus_acpi: world-writable procfs files
From: Corentin Chary <corentin.chary@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Karol Kozimor <sziwan@users.sourceforge.net>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-By: Corentin Chary <corentincj@iksaif.net>

Anyway, the driver is deprecated and will be removed someday.
