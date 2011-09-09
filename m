Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab1IINCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 09:02:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49302 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758754Ab1IINCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 09:02:02 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: balbi@ti.com, gregkh@suse.de,
        "Klaus Schwarzkopf" <schwarzkopf@sensortherm.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb gadget: clean up files
References: <1315572737-11991-1-git-send-email-schwarzkopf@sensortherm.de>
Date: Fri, 09 Sep 2011 15:01:58 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v1jk5kz13l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1315572737-11991-1-git-send-email-schwarzkopf@sensortherm.de>
User-Agent: Opera Mail/11.51 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Sep 2011 14:52:17 +0200, Klaus Schwarzkopf  
<schwarzkopf@sensortherm.de> wrote:

> remove the following two paragraphs:
>
> This program is distributed in the hope that it will be useful, but
> WITHOUT ANY WARRANTY; without even the implied warranty of  
> MERCHANTABILITY or
> FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
> License for more details.
>
> You should have received a copy of the GNU General Public License along  
> with
> this program; if not, write to the Free Software Foundation, Inc.,59
> Temple Place - Suite 330, Boston, MA  02111-1307, USA.

I'd add some justification.  Ie. the fact that the address is no longer  
valid.

> Signed-off-by: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>

> diff --git a/drivers/usb/gadget/amd5536udc.c  
> b/drivers/usb/gadget/amd5536udc.c
> index 95e8138..e5802a0 100644
> --- a/drivers/usb/gadget/amd5536udc.c
> +++ b/drivers/usb/gadget/amd5536udc.c
> @@ -9,14 +9,6 @@
>   * the Free Software Foundation; either version 2 of the License, or
>   * (at your option) any later version.
>   *

You've left the sole empty line.  Applies to some other files as well.

> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA   
> 02111-1307  USA
>   */
> /*

> diff --git a/drivers/usb/gadget/epautoconf.c  
> b/drivers/usb/gadget/epautoconf.c
> index 9b7360f..cff842e 100644
> --- a/drivers/usb/gadget/epautoconf.c
> +++ b/drivers/usb/gadget/epautoconf.c
> @@ -8,14 +8,7 @@
>   * the Free Software Foundation; either version 2 of the License, or
>   * (at your option) any later version.
>   *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA   
> 02111-1307  USA
> +

Something fishy going on here.  Why empty line?

>   *
>   */

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
