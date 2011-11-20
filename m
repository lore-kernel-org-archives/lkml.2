Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab1KTNYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 08:24:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33955 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab1KTNYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 08:24:34 -0500
Message-ID: <4EC8FF93.7010706@suse.cz>
Date: Sun, 20 Nov 2011 14:24:35 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        Jean Sacren <sakiwit@gmail.com>, linux-kernel@vger.kernel.org,
        vamos-dev@lists.informatik.uni-erlangen.de
Subject: Re: [PATCH] kconfig: Fix checking return value of 'fwrite'
References: <87lisype1v.fsf@faui43f.informatik.uni-erlangen.de> <CACqU3MWZuqgpxG7FSvr2LkqTqwF-gQM8hQSnTTpHpcWT2LHGNA@mail.gmail.com>
In-Reply-To: <CACqU3MWZuqgpxG7FSvr2LkqTqwF-gQM8hQSnTTpHpcWT2LHGNA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.10.2011 05:29, Arnaud Lacombe wrote:
> Hi,
> 
> 2011/10/6 Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>:
>> fwrite indicates '1' written member if a zero-length string is written.
> you forgot the "Signed-off-by: " part :)

Reinhard, can I assume

Signed-off-by: Reinhard Tartler
<Reinhard.Tartler@informatik.uni-erlangen.de>

? The patch is otherwise correct.

Michal
