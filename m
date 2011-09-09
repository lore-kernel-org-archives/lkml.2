Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715Ab1IINRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 09:17:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758941Ab1IINRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 09:17:18 -0400
Message-ID: <4E6A11DD.3060705@suse.cz>
Date: Fri, 09 Sep 2011 15:17:17 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Shakthi Kannan <shakthimaan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CRC calculation in Module.symvers
References: <CABG-yt0t0sgAvcDDLhjyNFGpY22tL0CtDvXV9+CxYJMf0MdVfA@mail.gmail.com> <4E67699E.80208@suse.cz> <CABG-yt030LAdqbRySzs8sj0Ajwst_c8RHf7yOyG9Eihh6mmf+w@mail.gmail.com>
In-Reply-To: <CABG-yt030LAdqbRySzs8sj0Ajwst_c8RHf7yOyG9Eihh6mmf+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.9.2011 06:50, Shakthi Kannan wrote:
> --- On Wed, Sep 7, 2011 at 6:24 PM, Michal Marek <mmarek@suse.cz> wrote:
> ---
> | And if you copy
> | the commandline without the >/dev/null redirection, you'll see the
> | calculated checksums on standard output.
> \--
> 
> Sorry, I didn't understand. Can you elaborate on what needs to be done here?

Copy the gcc ... | genksyms ... commandline printed by make V=1
crypto/api.symtypes.

Michal
