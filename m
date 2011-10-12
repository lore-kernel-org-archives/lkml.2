Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab1JLHz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:55:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64847 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1JLHz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:55:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAOULuOYy3HKbmFa8e9MFDCrduQKZhzgZ2CTskXTWxKCmFNRSRQ@mail.gmail.com>
References: <20111006190526.GA13883@redhat.com> <CAOULuOYy3HKbmFa8e9MFDCrduQKZhzgZ2CTskXTWxKCmFNRSRQ@mail.gmail.com>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Wed, 12 Oct 2011 09:55:36 +0200
Message-ID: <CALxABCaNGyu5Ef+eRVXQ_JPaKUNjQ6OS76Suix4BM3YryrNXNQ@mail.gmail.com>
Subject: Re: RFC: virtualbox tainting.
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 02:57, Parag Warudkar <parag.lkml@gmail.com> wrote:
> Why can't the automatic bug filing tools have a user space list of
> offending modules that it can use to opt out of automatically filing
> kernel bugs? ...

Maybe because an oops is not always conveniently accompanied by enough
information
to opt-out.
