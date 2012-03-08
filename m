Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2CHK3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:29:49 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55116 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2CHK3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:29:47 -0500
MIME-Version: 1.0
In-Reply-To: <7v7gyvkh84.fsf@alter.siamese.dyndns.org>
References: <7v7gyvkh84.fsf@alter.siamese.dyndns.org>
From: Nguyen Thai Ngoc Duy <pclouds@gmail.com>
Date: Thu, 8 Mar 2012 17:29:16 +0700
Message-ID: <CACsJy8CYTnrcAX6TNORdg=KAk4_xNupT11Uw8o8gnW6NtQtMCA@mail.gmail.com>
Subject: Re: [ANNOUNCE] Git 1.7.10-rc0
To: Junio C Hamano <gitster@pobox.com>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 8:35 AM, Junio C Hamano <gitster@pobox.com> wrote:
>  * "git clone" learned "--single-branch" option to limit cloning to a
>   single branch (surprise!).

--single-branch also limits fetching tags to minimum, I'm not sure we
need to mention that. It may be a good idea to mention "shallow clone"
or --depth, where this feature is most beneficial, to catch people's
eyes if they are interested in shallow clone.
-- 
Duy
