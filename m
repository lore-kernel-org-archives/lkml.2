Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1GLKBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 06:01:53 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40052 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1GLKBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 06:01:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfuBxyhh=3rO9MLkfDic16mij4A6NLXEQnhsvHEmBKokMoF7A@mail.gmail.com>
References: <CAJfuBxyhh=3rO9MLkfDic16mij4A6NLXEQnhsvHEmBKokMoF7A@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 12 Jul 2011 12:01:31 +0200
X-Google-Sender-Auth: 9TTUogL5EWY81MCiq7NIYyuoNEM
Message-ID: <CAO+b5-oFH4WHe6_tUibrqUjgBYZNDNoKCA0f67gMFJurLkGaKQ@mail.gmail.com>
Subject: Re: [ patch 00/21 ] support multiple, pending ddebugs at kernel-boot
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 5:21 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> TODO:
>> [ ... ]
>> 3. Decide whether to keep pending on list after they apply.
>> Given that user added 'a' flag, and can now delete them, its
>> reasonable to leave them on pending list.  Bart's point, TBD.

It's good that users can not only add items to the pending list but
that they can remove items from the pending list too. Does v2 of this
patch set provide a way to query the pending list ? If not, should
such a facility be provided ?

Bart.
