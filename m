Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1ILTJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 15:09:03 -0400
Received: from mail.infrascan.de ([188.40.84.136]:39839 "EHLO infrascan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab1ILTI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 15:08:59 -0400
Message-ID: <4E6E58C9.7090901@sensortherm.de>
Date: Mon, 12 Sep 2011 21:08:57 +0200
From: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        mina86@mina86.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: clean up FSF boilerplate text
References: <1315686255-12892-1-git-send-email-schwarzkopf@sensortherm.de> <20110910221045.04953572@lxorguk.ukuu.org.uk> <20110911004420.GA3413@suse.de> <20110911093625.325b9ea4@lxorguk.ukuu.org.uk> <20110912172407.GA8044@xanatos>
In-Reply-To: <20110912172407.GA8044@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.09.2011 19:24, schrieb Sarah Sharp:
> On Sun, Sep 11, 2011 at 09:36:25AM +0100, Alan Cox wrote:
>> On Sun, 11 Sep 2011 02:44:20 +0200
>> Greg KH<gregkh@suse.de>  wrote:
>>
>>> On Sat, Sep 10, 2011 at 10:10:45PM +0100, Alan Cox wrote:
>>>> On Sat, 10 Sep 2011 22:24:15 +0200
>>>> Klaus Schwarzkopf<schwarzkopf@sensortherm.de>  wrote:
>>>>
>>>>>      remove the following two paragraphs:
>>>>
>>>> NAK this for anything containing my copyright. NAK the one about warranty
>>>> and liability because its incredibly important, although of course if
>>>> you'd like to take personal liability...
>>>
>>> Odd, I was told that if you have the "this is covered under the GPLv2"
>>> then that's all that is needed for a single file in a larger body of
>>> work, like the kernel.
>>
>> People regularly take files out of the kernel or display only one of
>> them. However it's a legal question which means changing it needs the
>> approval of the right subspecies ....
>>
>> You may be right, but it should go past the appropriate expert for the
>> change, just like anything else.
>>
>>> But you do agree about the address paragraph being able to be removed,
>>> right?
>>
>> <wears parrot outfit>
>> That is a legal question. I am not a lawyer. Please discuss with Intel
>> before removing any disclaimers other license material.
>> </>
>>
>> Sqwark!
>
> Alan's probably right at least about the warranty bit, so I'll have to
> NAK for the changes to the xHCI driver (which are copyright Intel).
> BTW, it would have been nice to be CC'd on the original patch. :)
>

Sorry, was 52 recipient, and i wouldn't spam the list.

> Sarah Sharp

My proposals:

1. do nothing, very easy ;-)
2. change the old address to the new one
3. remove the address paragraph and add the following text (from 
http://www.gnu.org/licenses/gpl.html):

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.


possibly change the url to, e.g. http://kernel.org/gpl2.txt

Regards,

Klaus Schwarzkopf







