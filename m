Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab2CMIf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:35:29 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:42955 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab2CMIfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:35:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120313.010406.769202674785007195.davem@davemloft.net>
References: <1331624093-12598-1-git-send-email-santoshprasadnayak@gmail.com>
	<20120313.010406.769202674785007195.davem@davemloft.net>
Date: Tue, 13 Mar 2012 14:05:24 +0530
Message-ID: <CAOD=uF6e_JKaEQbFV=78JmuMBSUOtP7L0cBZr2zSv+Zgwq==qQ@mail.gmail.com>
Subject: Re: [PATCH 3/3 v3] netxen: qlogic ethernet : Fix endian bug.
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sony.chacko@qlogic.com, rajesh.borundia@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My mistake.
Normally I compile before sending the patch. This time I forgot.

Sorry for the inconvenience.


regards
Santosh

On Tue, Mar 13, 2012 at 1:34 PM, David Miller <davem@davemloft.net> wrote:
>
> You didn't even compile test this.
>
>> -     if (*mac == cpu_to_le64(~0ULL)) {
>> +     if (*mac == ~0ULL)) {
>
> This is unacceptable, I'm ignoring you for at least a week.
>
