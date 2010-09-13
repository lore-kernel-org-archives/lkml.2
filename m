Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0IMRmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:42:03 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49280 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab0IMRmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:42:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:in-reply-to:references:user-agent:date:message-id
         :mime-version:content-type;
        b=R0Yg7htvOHGN4XXaC4zwxruCQIp9bOYGaGX5vBnhQj26wwNYaxFoqm5rUAMV/OuH/z
         ZNjEbvtk+wHqiwn7ZnEr5PyLWEW0KYHgNd+j0LFgIWThakrz4GQk/wXhkT7gBhEZHPs5
         UZgpwjd1j1OTDim2oXHVOdLIQkvU2/iIooCAg=
From: Ben Gamari <bgamari@gmail.com>
To: Heiko Bauke <heiko.bauke@snafu.de>, linux-kernel@vger.kernel.org
Subject: Re: Realtek Ethernet drivers
In-Reply-To: <20100913095912.74d7f0f1@tron.localdomain>
References: <20100912210444.76ebeee6@tron.localdomain> <20100912223724.GA15934@electric-eye.fr.zoreil.com> <20100913095912.74d7f0f1@tron.localdomain>
User-Agent: Notmuch/0.3.1-62-g4723706 (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Mon, 13 Sep 2010 13:41:52 -0400
Message-ID: <87vd69v8v3.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 09:59:12 +0200, Heiko Bauke <heiko.bauke@snafu.de> wrote:
> > But it misses 81a95f049962ec20a9aed888e676208b206f0f2e and
> > 024a07bacf8287a6ddfa83e9d5b951c5e8b4070e
> 
> I thank you for your reply. If there is time I will try a more recent
> kernel. (For the moment the Realtek drivers are fine for me.) I
> know how to (re-)compile distribution kernels and how to compile a
> vanilla kernel from kernel.org. However, I have no idea what the
> hex-codes you mentioned mean. Can you give me a hint?
> 
These are git (the version control system used for kernel development)
commit ids.

- Ben
