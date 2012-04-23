Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab2DWWwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:52:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34240 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab2DWWwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:52:33 -0400
MIME-Version: 1.0
In-Reply-To: <CA+7oygc839sn-s3hHo0XBA_BJop86hZB1h987af1caJ6pAOwyw@mail.gmail.com>
References: <CA+7oygfcQbOFdCFibTW0pqYQpcLwrqCM_jvKpr=GYFBMn9t3GQ@mail.gmail.com>
	<20120423212144.GA3378@kroah.com>
	<CA+7oygc839sn-s3hHo0XBA_BJop86hZB1h987af1caJ6pAOwyw@mail.gmail.com>
Date: Mon, 23 Apr 2012 18:52:32 -0400
Message-ID: <CA+7oygcpheWc8xyM1vndYKVJpLzm3zxVWF=9UBYP0xasZPEsew@mail.gmail.com>
Subject: Re: what determines how firmware is loaded? (Q. on request_firmware details)
From: George Nychis <gnychis@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I managed to get the "manual" way going by calling
_request_firmware() directly, but I get the same error.  Looks like
this will required some USB debugging.

Thanks!
George
