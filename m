Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab1DZMbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:31:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58377 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab1DZMa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TR+zeBVgSgM9VXNMPk/QGusqEBSDKSr5KHEoduM8yjzdmfS+QcIVkF11glTxoTm6hp
         6GgXmTh92uskfUXjFM4KHK+Ey5JcQKyNgdYuPlqgkcsdCHWH9yFNnd0QScQGmeVlcKCw
         tWT2fdNjgpm6mBKyrC4NJXCJ2tq7S/FU3HgFs=
Message-ID: <4DB6BAFF.8080302@gmail.com>
Date: Tue, 26 Apr 2011 14:30:55 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0a2) Gecko/20110420 Thunderbird/3.3a4pre
MIME-Version: 1.0
To: Amit Ben Shahar <amit.bens@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Why is the 'loff_t *offset' parameter in the file_operations'
 read function a pointer?
References: <BANLkTimaJFFCCQOA6=G4i95PsJK_S2bf9Q@mail.gmail.com>
In-Reply-To: <BANLkTimaJFFCCQOA6=G4i95PsJK_S2bf9Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2011 01:58 PM, Amit Ben Shahar wrote:
> (if i'm off topic or should look elsewhere i apologize - couldn't find
> information anywhere)
> I am coding a kernel module and implementing a file's operations, the
> read operation received an loff_t *offset parameter, why is this a
> pointer?

Because you are responsible for changing it appropriately.

> is it in userspace?

Nope, in kernelspace.

I think this is described in LDD3, isn't it?

regards,
-- 
js
