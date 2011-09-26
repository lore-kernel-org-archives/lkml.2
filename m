Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab1IZMrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 08:47:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47133 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab1IZMrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 08:47:11 -0400
MIME-Version: 1.0
In-Reply-To: <7vhb42su6f.fsf@alter.siamese.dyndns.org>
References: <7vhb42su6f.fsf@alter.siamese.dyndns.org>
Date: Mon, 26 Sep 2011 14:47:09 +0200
Message-ID: <CACBZZX77ZhdS1cyiYpjJcuvSnJsv15FUumPWeZOcwh_b41c2FQ@mail.gmail.com>
Subject: Re: [ANNOUNCE] Git 1.7.7.rc3
From: =?UTF-8?B?w4Z2YXIgQXJuZmrDtnLDsCBCamFybWFzb24=?= <avarab@gmail.com>
To: Junio C Hamano <gitster@pobox.com>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 01:41, Junio C Hamano <gitster@pobox.com> wrote:

> Also the following public repositories all have a copy of the v1.7.7-rc3
> tag and the master branch that the tag points at:

The 1.7.7-rc* series still doesn't compile on older Red Hat machines
because 4c1be38b4a236403a329187acb70591a7fd92150 hasn't been included
in it.

Could you please include that in the final 1.7.7? It would be a PITA
to have to work around that.
