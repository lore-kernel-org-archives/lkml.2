Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab0HIWM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:12:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46143 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab0HIWMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:12:25 -0400
MIME-Version: 1.0
In-Reply-To: <4C607998.90509@gmail.com>
References: <4C5F9B25.8080401@st.com>
	<201008091735.11105.mihai.dontu@gmail.com>
	<4C6040FC.2020702@gmail.com>
	<201008092115.25992.mihai.dontu@gmail.com>
	<1281389338.7143.32.camel@localhost>
	<4C607998.90509@gmail.com>
Date: Mon, 9 Aug 2010 23:12:22 +0100
Message-ID: <AANLkTimVMUvJLG2N5dPYAHpw8wyLdQpYaUF+F4Trw8eb@mail.gmail.com>
Subject: Re: Query: Patches break with Microsoft exchange server.
From: Valeo de Vries <valeo@valeo.co.cc>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 August 2010 22:56, Justin P. Mattock <justinmattock@gmail.com> wrote:
> On 08/09/2010 02:28 PM, David Woodhouse wrote:
>>
>> On Mon, 2010-08-09 at 21:15 +0300, Mihai Donțu wrote:
>>>
>>> Wait. I don't think we're on the same page here. I'm talking about
>>> message
>>> signing (which does not require the receiving end to have any key - it's
>>> the
>>> same plain text e-mail with a blob after it) while you refer to actually
>>> encrypting the message. Mm? Or am I being extremely slow today? :-)
>>
>> Only when you assume that Exchange would pass signed messages without
>> corrupting them. It really is that broken.
>>
>
> figured the encryption would be kind of a last resort situation..but if it's
> that broken to where it wont pass it along without corrupting, then the best
> solution is to figure out what Microsoft needs in terms of encoding, i.e. is
> there a way to have the scanner scan but not throw everything around after
> it scans.(if this is what it's doing)

The link I posted earlier seems to give the impression that
quoted-printable might do that. I may have misread that, though...

Valeo
